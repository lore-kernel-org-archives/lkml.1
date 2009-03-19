Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZCSM7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZCSM7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 08:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZCSM73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 08:59:29 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:47671 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752726AbZCSM72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 08:59:28 -0400
Subject: Re: High contention on the sk_buff_head.lock
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vernon Mauery <vernux@us.ibm.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <87prge1rhu.fsf@basil.nowhere.org>
References: <49C12E64.1000301@us.ibm.com> <87prge1rhu.fsf@basil.nowhere.org>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Thu, 19 Mar 2009 06:59:19 -0600
Message-Id: <1237467559.6926.31.camel@hermosa>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 21:54 +0100, Andi Kleen wrote:
> Vernon Mauery <vernux@us.ibm.com> writes:
> >

> 
> But then again I'm not sure it's  worth it if the problem only
> happens in out of tree RT.
> 

Heh.  That darn bastard child again, eh?  :-)


Recall that adaptive spin,developed in RT, is now in mainline. 

Best,
-PWM


