Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbZFKIxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbZFKIxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZFKIxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:53:08 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:37478 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZFKIxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:53:07 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 04:53:07 EDT
MIME-Version: 1.0
In-Reply-To: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
Date: Thu, 11 Jun 2009 18:46:00 +1000
Message-ID: <1d3f23370906110146w623419b8s41661c83490f588d@mail.gmail.com>
Subject: Re: Microblaze MMU v2
From: John Williams <john.williams@petalogix.com>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, michal.simek@petalogix.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 4:47 PM, Michal Simek<monstr@monstr.eu> wrote:

> This is bunch of patches for Microblaze MMU kernel support version 2.
> There is one problem(not functional) with uaccess.h which I know about and I would like
> to fix it till rc2 with Arnd's new generic patches which I hope will be there.

I've boot tested both MMU and noMMU configs of this tree - all looks great.

Tested-by: John Williams <john.williams@petalogix.com>
Signed-off-by: John Williams <john.williams@petalogix.com>

John
--
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
