Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbZKLAaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbZKLAaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759743AbZKLAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:30:50 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:38617 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739AbZKLAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:30:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xup15dZKa/aEukDUgaaSYulGTmK1HoXBFz5iqADhfG66XRlAVvuJOF1MsEiHtQ5hIg
         a5nRx2umv0vJTNmtbuvqsgMd6PnLj/4ZEmXVmwn5Eky12UKl3hrIIVOfbCyTqGfv26zx
         fEZdevy1xcNppqUNwNBqScyVIpT06t2H36Lic=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0911041427400.9988@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-5-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0911041427400.9988@wotan.suse.de>
Date: Thu, 12 Nov 2009 02:30:55 +0200
Message-ID: <94a0d4530911111630x7dfb0c5erbbbfa54e4a385d42@mail.gmail.com>
Subject: Re: [PATCH 4/7] acpi: processor: fix section mismatch
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Myron Stowe <myron.stowe@hp.com>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 3:28 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> I don't see this patch in today's linux-next ... ACPI guys, are you going
> to merge it?

How critical are these section mismatch issues? Should this go into 2.6.32?

-- 
Felipe Contreras
