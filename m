Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZFVSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZFVSqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZFVSqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:46:12 -0400
Received: from mx.treblig.org ([80.68.94.177]:35919 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZFVSqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:46:11 -0400
Date: Mon, 22 Jun 2009 20:46:05 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090622194605.GA25820@gallifrey>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey> <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz> <20090617193442.GA31944@gallifrey> <alpine.LNX.2.00.0906180126260.7457@wotan.suse.de> <20090620120357.GA11272@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620120357.GA11272@gallifrey>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 19:56:42 up 27 days, 12:18,  2 users,  load average: 0.07, 0.07, 0.02
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That I wrote.
> 
> Yes, with i8042.noaux it works; dmesg snippet included below.
> 
> And in reply to hpa, it doesn't have a mouse port.

Jiri,
I saw you also asked for  a dmidecode -t system
dmidecode says the machine has 'No SMBIOS nor DMI entry point'.

Dave 
P.S. Apologies for not keeping the threading correct - I hit 'd' once too
often.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
