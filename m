Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXDIS1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXDIS1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXDIS1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:27:01 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbXDIS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:26:58 -0400
Message-ID: <461A84FD.6010400@zytor.com>
Date: Mon, 09 Apr 2007 11:25:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu>	 <20070406160238.f3178189.akpm@linux-foundation.org>	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>	 <20070409143802.GB4891@sergelap.austin.ibm.com>	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>	 <20070409170743.GF24415@sergelap.austin.ibm.com> <1176140785.2842.18.camel@ram.us.ibm.com>
In-Reply-To: <1176140785.2842.18.camel@ram.us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram Pai wrote:
> 
> It is in FC6. I dont know the status off upstream util-linux. I did
> submit the patch many times to Adrian Bunk (the then util-linux
> maintainer) and got no response. I have not pushed the patches to the
> new maintainer(Karel Zak?) though.
> 

Well, do that, then :)

Seriously.  The whole point of util-linux-ng is to make forward progress.

	-hpa
