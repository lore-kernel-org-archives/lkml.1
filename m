Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbZDQCac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbZDQCac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbZDQCaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:30:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:38099 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbZDQCaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
	 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
	 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
Date: Fri, 17 Apr 2009 12:25:21 +1000
Message-ID: <1d3f23370904161925l41a375afp70eb016ffa90fb8c@mail.gmail.com>
Subject: Re: [microblaze-uclinux] [PATCH 02/11] microblaze: Remove while(1) 
	loop from show_regs function
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 7:56 PM,  <monstr@monstr.eu> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
> I removed it because of show_regs can't break die function.
> If process/kernel failed, die (do_exit) function resolve it.

ACK

-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
