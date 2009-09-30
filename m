Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbZI3TqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbZI3TqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbZI3TqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:46:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbZI3TqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:46:08 -0400
Date: Wed, 30 Sep 2009 12:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tomaz.mertelj@guest.arnes.si
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments 
 amc6821 chip
Message-Id: <20090930124426.4d4528b7.akpm@linux-foundation.org>
In-Reply-To: <20090923_093247_088063.tomaz.mertelj@guest.arnes.si>
References: <20090923_093247_088063.tomaz.mertelj@guest.arnes.si>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 11:32:47 +0200
tomaz.mertelj@guest.arnes.si wrote:

> On Wed, 9 Sep 2009 09:34:35 +0200
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > > And then do all the real work in a common function?  Rather than
> > > expanding tens of copies of the same thing?
> >
> > Yes please. We got rid of macro-generated callbacks in most hwmon
> > drivers a couple years ago already.
> 
> Here is an incremental patch to TI amc6821 chip hwmon driver:

The patch is hopelessly wordwrapped.  Please fix and resend?
