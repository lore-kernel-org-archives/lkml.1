Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbYIDIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbYIDIh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYIDIhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:37:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:8455 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYIDIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:37:15 -0400
Date: Thu, 4 Sep 2008 10:37:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
Subject: Re: qestion about I2C_CLASS_HWMON flag
Message-ID: <20080904103707.557ac764@hyperion.delvare>
In-Reply-To: <38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	<38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francis,

On Thu, Sep 4, 2008 at 9:43 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> I'm wondering why does this flag exist ?
>
> Why is a hw monitor device so special so that an I2C bus needs
> a flag to tell the rest of the world that it support it ?

I don't understand your point. We have I2C_CLASS flags for many I2C
device types (analog TV, digital TV, etc.) I2C_CLASS_HWMON isn't the
exception you describe. Look at <linux/i2c.h> for a list of these flags.

-- 
Jean Delvare
