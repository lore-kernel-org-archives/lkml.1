Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbYJaLxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbYJaLxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYJaLw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:52:56 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:35491 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYJaLwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d4ikmmMIjtc10XeVMzPq0B/s1keUC8pS1C37LWkHAFXIm0Pv7kRu+syHPsQBxBoREU
         VBKmEFFSl3Ep1kpe0aT2iv9FtSyQIfJl9RyJIvuS/JfdCXRdM4FTv5E1QAMiGbS5HCZY
         FwACQ1XuW855PqAM0jcOATa/7qsBuvaObqvrw=
Message-ID: <df9815e70810310452g3a6416cai6ff5cf25f4b7643b@mail.gmail.com>
Date: Fri, 31 Oct 2008 19:52:53 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "jidong xiao" <jidong.xiao@gmail.com>
Subject: Re: Where is asm-ia64 directory in 2.6.27 kernel?
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4104961b0810310445v49e13b85xe85d417bfe9ad979@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0810310445v49e13b85xe85d417bfe9ad979@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 7:45 PM, jidong xiao <jidong.xiao@gmail.com> wrote:
> Hi,
>
> I just noticed there is no such a directory now, where are the
> including files re-located?Is it also merged into asm-x86??

It's moved to arch/ia64/include ;-)
