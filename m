Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbXHFFWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbXHFFWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 01:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXHFFWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 01:22:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:37177 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbXHFFWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 01:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LIOx+PW77yB10mr3cGxbgVoCW2kAbsAsVctHOWSmUP8yz0UtAMr1PRHUq3q5I6cB0rBnRKDTH3oqr+V8X0Si5uzPyq1sN4ADl7F8NUC4VWbeUUCNXc/XJ0Ahc4z4a9O9XFZvSsnND3NSy88E6BnHvPErpAUNdMv0pR82OwDGzo0=
Message-ID: <46B6B006.6000100@gmail.com>
Date: Mon, 06 Aug 2007 14:22:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBzZWQ=?= <sedmich@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, hmh@hmh.eng.br
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
In-Reply-To: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing Henrique.  Any ideas?

Michał sed wrote:
> Greetings
> 
> I'm experiencing double disk spin down issue on my HP nx6310 laptop
> during shut down and suspend to disk. The drive is power down on "Will
> now halt message" then turned back on and off again with the laptop
> itself. I'm using the newest bios available F.0D, 2.6.23-rc1-mm kernel
> along with Debian Unstable plus fixes from Sidux repository so I have
> the updated shut down script. I have also verified on two other systems
> [AMD/Nforce based] that the spin down issue has been resolved by the
> Sidux update and I'm certain that this is a hp bios bug or a piix kernel
> module problem.
> 
> Michael



-- 
tejun
