Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbXJSLyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbXJSLyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757134AbXJSLyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:54:33 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49825 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097AbXJSLyc convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:54:32 -0400
Message-ID: <47189AD3.8010301@bull.net>
Date: Fri, 19 Oct 2007 13:53:55 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: carsteno@de.ibm.com
Cc: "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net>	<47189706.1040809@de.ibm.com> <4718982D.4020500@bull.net> <471899CA.8060206@de.ibm.com>
In-Reply-To: <471899CA.8060206@de.ibm.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/10/2007 14:01:03,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/10/2007 14:01:03,
	Serialize complete at 19/10/2007 14:01:03
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte a écrit :
> Laurent Vivier wrote:
>> How do you know the problem has been introduced by kvm ?
> I don't. In fact I think it has not been introduced by kvm. All I 
> stated, is that we experienced the problem when running the kvm.git 
> kernel after the 2.6.23 update that has not been present in the 
> kvm.git -rc8 as of last thursday.

Perhaps 2.6.23.1 corrects this ?

http://lkml.org/lkml/2007/10/12/302

Laurent
-- 
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond

