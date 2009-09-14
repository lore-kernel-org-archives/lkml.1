Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZINNzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZINNzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZINNzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:55:10 -0400
Received: from fifo99.com ([67.223.236.141]:52895 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbZINNzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:55:09 -0400
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Daniel Walker <dwalker@fifo99.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 06:55:56 -0700
Message-Id: <1252936556.28368.215.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 22:38 +0300, Felipe Contreras wrote:
> drivers/acpi/acpica/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
> arch/x86/include/asm/string_32.h:74: warning: array subscript is above array bounds
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Could you run this through checkpatch also, it looks like you have a few
style issues..

Daniel

