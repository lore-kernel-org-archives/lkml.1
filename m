Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXJSLnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXJSLnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbXJSLnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:43:15 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46346 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbXJSLnP convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:43:15 -0400
Message-ID: <4718982D.4020500@bull.net>
Date: Fri, 19 Oct 2007 13:42:37 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: carsteno@de.ibm.com
Cc: Aurelien Jarno <aurelien@aurel32.net>,
       "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net> <47189706.1040809@de.ibm.com>
In-Reply-To: <47189706.1040809@de.ibm.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/10/2007 13:49:43,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/10/2007 13:49:43,
	Serialize complete at 19/10/2007 13:49:43
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte a écrit :
> Aurelien Jarno wrote:
>> Could you please precise what is corrupted? The guest disk image?
> As stated, we actually did not run any guests and did not load the kvm 
> kernel modules.
> The host root file system gets corrupted to an extend not correctable 
> by the file system checker (we gave it 24h to repair, then interrupted 
> it), and it's very easy to reproduce: a simple kernel make on the 
> hosts lets us reinstall the entire host operating system.

How do you know the problem has been introduced by kvm ?

Laurent
-- 
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond

