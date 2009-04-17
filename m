Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbZDQAtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbZDQAtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761266AbZDQAqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:46:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55137 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761260AbZDQAqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:46:36 -0400
Date: Fri, 17 Apr 2009 01:46:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Nicholson <robert.nicholson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does the linux kernel contain support for ATA Security feature set?
Message-ID: <20090417004633.GB869@srcf.ucam.org>
References: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 06:49:59PM -0500, Robert Nicholson wrote:
> So, I've got an X-25M that I want to securely erase and it turns out  
> on a Mac I'm not going to be able to issue the command because it  
> doesn't support legacy IDE mode from what I understand. So the idea of  
> a any boot CD that I could boot and run a program that can issue a  
> SECURE_ERASE (SE) to the drive is only applicable to PC's.

Why is the lack of legacy IDE an issue? hdparm works fine with SATA 
setups.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
