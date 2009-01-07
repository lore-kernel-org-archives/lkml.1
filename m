Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbZAGPGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbZAGPGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZAGPGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:06:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:56830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZAGPGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:06:14 -0500
Date: Wed, 7 Jan 2009 07:08:10 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/6] v2: Asynchronous function calls to speed up booting
 and more
Message-ID: <20090107070810.675799a5@infradead.org>
In-Reply-To: <48f7fe350901061919l55006cd6v842e3f7a40e4cd0c@mail.gmail.com>
References: <20090105201508.23e98b4b@infradead.org>
	<48f7fe350901061919l55006cd6v842e3f7a40e4cd0c@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009 22:19:33 -0500
"Ryan Hope" <rmh3093@gmail.com> wrote:

> i can't boot with these patches... the kernel panic was something
> along the line of:
> 
> ata_piix: device unavailable because of BAR 0 collisions

ok as a hunch.. could you try this but without the ACPI part of the
patch?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
