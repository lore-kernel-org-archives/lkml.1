Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZEKQiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZEKQiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZEKQh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:37:58 -0400
Received: from gw.goop.org ([64.81.55.164]:33912 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbZEKQh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:37:57 -0400
Message-ID: <4A085464.5030802@goop.org>
Date: Mon, 11 May 2009 09:37:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet> <4A043E89.90403@novell.com> <4A044786.2080508@codemonkey.ws> <4A047EDE.2020806@redhat.com> <4A0481AC.7070409@codemonkey.ws>
In-Reply-To: <4A0481AC.7070409@codemonkey.ws>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Yes, I misunderstood that they actually emulated it like that.  
> However, ia64 has no paravirtualization support today so surely, we 
> aren't going to be justifying this via ia64, right?
>

Someone is actively putting a pvops infrastructure into the ia64 port, 
along with a Xen port.  I think pieces of it got merged this last window.

    J
