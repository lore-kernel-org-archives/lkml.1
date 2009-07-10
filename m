Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbZGJEqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbZGJEqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 00:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZGJEpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 00:45:54 -0400
Received: from web15702.mail.cnb.yahoo.com ([202.165.102.69]:47650 "HELO
	web15702.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750774AbZGJEpy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 00:45:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=4pKYdicgb8GoVo/lQH7ysSbhvORK2i/vD5uosuwU9bfvTb1TA7iFRMzJwkOivlqXhhr21f6mNm4sgW7HFX0s3E7obKcn24QYjPVEpMjco6iKLEq5yK0Ge2gc0iJCAtY5uhTy+yHUT8EzHWOHWCN7yZBCq8nHfdnp1dl2XOyWQ7k=;
Message-ID: <831830.41746.qm@web15702.mail.cnb.yahoo.com>
X-YMail-OSG: gOuccIQVM1kgyyiLUapxP15z_E_2Nw8HVl9rBHc5MfEv8DAiviDJ678y9S6T4LXqW89MlbWnydaZPAMAD5BzANHv5Rsvlio8BErvd2L0VLHD_ZSuBSREyVTNgGhQATuFC5COP58cV4wKJtdW0Niwpe7qX7T0yahJPg59StY3cO7F0Vlh_YrbZoIUQd6M7t6J0fyhzsgOnxcf.w--
X-Mailer: YahooMailClassic/5.4.17 YahooMailWebService/0.7.289.15
Date: Fri, 10 Jul 2009 12:45:51 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Subject: Re: Ask a question related Assemble and C revert  within vmlinux ?
To: Albert ARIBAUD <albert.aribaud@free.fr>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,Albert

Thanks .

--- On Thu, 7/9/09, Albert ARIBAUD <albert.aribaud@free.fr> wrote:

> From: Albert ARIBAUD <albert.aribaud@free.fr>
> Subject: Re: Ask a question related Assemble and C revert  within vmlinux ?
> To: "peter meng" <mengsanshui@yahoo.com.cn>
> Cc: linux-kernel@vger.kernel.org
> Date: Thursday, July 9, 2009, 7:35 PM
> peter meng a écrit :
> > Hi
> > 
> > I compile the linux kernel with mips .
> > Is there any tools let the Assemble code correspond to
> C code ?
> > I mean Assemble line correspond to C line .
> 
> Look up you C compiler's command line options. There should
> be several to generate listings, with either assembly or
> mixed assembly and C.
> 
> Or if your tool chain has the objdump utility, objdump also
> has options to disassemble, and possibly intermix source
> code lines.
> 
> Amicalement,
> -- Albert.
> 


      
