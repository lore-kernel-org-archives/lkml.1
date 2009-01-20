Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbZATSqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbZATSqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZATSqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:46:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:29996 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZATSqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:46:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PAMTl/d8K7mu2MLgKArXsFXc+0gnzfvI/b0RhVEru2+sW9bMECgSHz2M+Rw4jTHRSH
         KlIQoQ0/BWq5uJy8wKCmiEVcYcAw7grrsNO3CjTTAH+AYqa6E4yApQHw0mb+hXKsNi/5
         d0LXnBbP1i88dMwEOTegviZXahP5X2AM61fMQ=
Message-ID: <72dbd3150901201046m4b9a64bbuaf4f1f469c975537@mail.gmail.com>
Date: Tue, 20 Jan 2009 10:46:03 -0800
From: "David Rees" <drees76@gmail.com>
To: "Mika Tiainen" <mikat@iki.fi>
Subject: Re: Slow clock on AMD 740G chipset
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <874ozu2hcl.fsf@divinity.mikat.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 6:16 AM, Mika Tiainen <mikat@iki.fi> wrote:
> I built a new machine with Gigabyte GA-MA74GM-S2H motherboard that ntpd
> can't keep synced. Could this be a kernel bug or is it a hardware
> problem?
>
> Installed with Debian 2.6.27 kernel and currently running a self built
> 2.6.28.1, both have the problem. It's falling behind over 2s/15min:

Hmm, I've got the same exact mobo running Fedora 10
2.6.27.9-159.fc10.x86_64 kernel - no issues with time syncrhonization
here.  I have a 5050e processor.  I'll try to run some diffs on my
dmesg against yours later...

-Dave
