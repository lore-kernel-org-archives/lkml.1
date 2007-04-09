Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbXDIRr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbXDIRr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbXDIRr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:47:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37010 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbXDIRrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:47:55 -0400
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ram Pai <linuxram@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070409170743.GF24415@sergelap.austin.ibm.com>
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	 <20070409143802.GB4891@sergelap.austin.ibm.com>
	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	 <20070409170743.GF24415@sergelap.austin.ibm.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 10:46:25 -0700
Message-Id: <1176140785.2842.18.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 12:07 -0500, Serge E. Hallyn wrote:
> Quoting Miklos Szeredi (miklos@szeredi.hu):

> >  - need to set up mount propagation from global namespace to private
> >    ones, mount(8) does not yet have options to configure propagation
> 
> Hmm, I guess I get lost using my own little systems, and just assumed
> that shared subtree functionality was making its way up into mount(8).
> Ram, have you been working on that?

It is in FC6. I dont know the status off upstream util-linux. I did
submit the patch many times to Adrian Bunk (the then util-linux
maintainer) and got no response. I have not pushed the patches to the
new maintainer(Karel Zak?) though.

RP

