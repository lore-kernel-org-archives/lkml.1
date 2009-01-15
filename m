Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbZAOP45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbZAOP45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZAOP4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:56:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:23209 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbZAOP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:56:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=LPxw5HhpkoAJXR9Un05kjdFUxAIaquasxt3KBK9YtM0aRHTSBKd8XAx9AixMGFOUmK
         eAMFsyLMYK/GeKRaYX/Ktw/kMujdTcrOiX5RGC2LFrOIt6iGGZQXNtWYAuFwIGJUSU5Z
         Ckd3elSUEjEhL4hwQs33Csjqa3bDgwIV+zmzY=
MIME-Version: 1.0
In-Reply-To: <3f9a31f40901120903yc6a85e0w4c2fe57352f1f482@mail.gmail.com>
References: <3f9a31f40901120903yc6a85e0w4c2fe57352f1f482@mail.gmail.com>
Date: Thu, 15 Jan 2009 21:26:46 +0530
Message-ID: <3f9a31f40901150756t2e62a640hdad6ccf6cef89b0b@mail.gmail.com>
Subject: Re: scripts/checkpatch.pl: WARNING: patch prefix 'arch' exists, 
	appears to be a -p0 patch
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, davej@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andy,

On Mon, Jan 12, 2009 at 10:33 PM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
>
>  #./scripts/checkpatch.pl --file arch/x86/kernel/module_32.c
> WARNING: patch prefix 'arch' exists, appears to be a -p0 patch
>
> total: 0 errors, 1 warnings, 152 lines checked
>

The problem is on my side or this is a BUG ?

Thanks
--
JSR
