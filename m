Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYIHPzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYIHPzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYIHPzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:55:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58893 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYIHPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:55:03 -0400
Date: Mon, 8 Sep 2008 16:54:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: Controlling backlight on thinkpad x60
Message-ID: <20080908155457.GA30619@srcf.ucam.org>
References: <20080908151058.GA1650@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908151058.GA1650@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 05:10:58PM +0200, Pavel Machek wrote:

> (I do have CONFIG_ACPI_VIDEO disabled, it killed my machine last time
> I enabled it, is it mandatory now?)

On Thinkpads with ACPI video support, yes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
