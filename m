Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYA0RgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYA0RgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYA0RgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:36:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:56012 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYA0RgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:36:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DeNYVEbHRWCURdClkW0pjQkP/fU+JtL2lt5Bqfu/5mw4CWAmDgqT8mq/ELdrK2dAYpbTEjtl2QsqRzTOWq9En0XHd9OeftdzMSIiDQThHC6d2O1JdFxCp6K7JrC2U4hfddQ6vZMAL8vDnnUpClIB++jD6CamkF74TLkGhTc1bPc=
Message-ID: <9e4733910801270936q7affdee3o3518c2265acaf61d@mail.gmail.com>
Date: Sun, 27 Jan 2008 12:36:03 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.25
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux I2C" <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080127182741.62bfe92a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127182741.62bfe92a@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/08, Jean Delvare <khali@linux-fr.org> wrote:
> Linus,
>
> Please pull the i2c subsystem updates for Linux 2.6.25 from:
>
> git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

The support for modalias loading of i2c modules isn't in here, what's
the status?

-- 
Jon Smirl
jonsmirl@gmail.com
