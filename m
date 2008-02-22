Return-Path: <linux-kernel-owner+w=401wt.eu-S1765974AbYBVAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765974AbYBVAnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761260AbYBVAnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:43:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:15379 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140AbYBVAm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DpDnR+IuzXoXCIaFXd0f3e6353E3K7PNrzPILqYGRU2WUd3OG7NutdHZJyI9P56/KYWn3NpOwKv2OsdjRZwO2aVNC4IG+ZjKR1T8PiaAdjibQ4AcucM1Rp8KTgMtT7jMk5YQlfoN1Qgn1McaFxpnwcHOJQvqFE3/iSWmiBnX0b8=
Message-ID: <b6a2187b0802211642i7f4cd764ocb5a66b49de78875@mail.gmail.com>
Date: Fri, 22 Feb 2008 08:42:59 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <200802220131.09525.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802211302.27002.jesse.barnes@intel.com>
	 <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com>
	 <200802220131.09525.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 8:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>  Jeff, can you please test hibernation with the patch I've just sent to Jesse
>  (reproduced below for convenience)?

Testing now.

Jeff.
