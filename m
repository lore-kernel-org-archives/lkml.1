Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYEQHQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYEQHQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYEQHQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:16:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:48794 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYEQHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f86a5uNkqjvwu79VtO0TcSNeBNENyz0NsaUT2HKSA8hzrkoj+fYuscjvqpb68JRQ7Qaa+fEk8eIEPosQHw78vxHJss8x0Vm5qgHZHshTG2wf7qt5T4HccWrBZHkt80WajaZbrSxeEiqL4RzCzxrObzq8exTSPkqL8/A0q6cuVeI=
Message-ID: <e2e108260805170016u5c8480dfxfbe4c896734717b6@mail.gmail.com>
Date: Sat, 17 May 2008 09:16:30 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Alok kataria" <alokkataria1@gmail.com>
Subject: Re: Kernel hangs in SMP + VMware environment.
Cc: tglx@linutronix.de, "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>,
       akataria@vmware.com, devzero@web.de, linux-kernel@vger.kernel.org,
       dhecht@vmware.com
In-Reply-To: <35f686220805162259g18c6bcf9rf87103a98933cc94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
	 <200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
	 <D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>
	 <200805162148.AAJ21381.QOSMOFFFLHOVJt@I-love.SAKURA.ne.jp>
	 <D3C12B2AD838B44DA9D6B2CA334246D00DC43DE5E6@PA-EXMBX04.vmware.com>
	 <200805171034.CJC04647.HOFMOJVFQFOLtS@I-love.SAKURA.ne.jp>
	 <35f686220805162259g18c6bcf9rf87103a98933cc94@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 7:59 AM, Alok kataria <alokkataria1@gmail.com> wrote:
> Sorry, but I am not aware of how the stable tree is maintained. Any
> information regarding that would be helpful.

See also Documentation/stable_kernel_rules.txt.

Bart.
