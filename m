Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbXJVHpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbXJVHpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXJVHpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:45:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:50127 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbXJVHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YeTMyUpmuTPVm8hBE+tzJhICT6wOMFTNDNB5fLcV1rzZkXZRhw/wTktT0oV03KA9DYDXyQtBrqWYL+XPGaXWg7IZLdBoSxEkCCtC35L+hnavw+hsf45CHx3mM8W2Ai32jCU+eZVE1Kf+cAMNeasRTE9tb4lL067ajSRmiwZ0e0U=
Message-ID: <b6a2187b0710220045q2920c0dat9ebe4850b02d1bbf@mail.gmail.com>
Date: Mon, 22 Oct 2007 15:45:39 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: latest 2.6.23 git missing ACPI POWER_SUPPLY
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just pulled latest linux-2.6, and couldn't get ACPI to detect
ACPI_BATTERY and ACPI_AC.

It seems ACPI POWER_SUPPLY is still missing.

Thanks,
Jeff.
