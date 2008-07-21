Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbYGUKon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbYGUKon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757940AbYGUKof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:44:35 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:25547 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbYGUKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=PhBVxKRxm06V8RWlvkQI9uelwbmZC+K1Lq71Dyb5vonl/wZQG3EeW7JaOAhigBNbId
         2dfBz7RQ+3x0R+kdW5nlUFjfbJX5ZNt02anZRkAyP9D70loFjcyYWaxUIRwYJNEyq21J
         k5BsrydszkS2kgyGRxTVXRPqRei0DERfbT6zs=
Message-ID: <5f6f8c5f0807210344l676f5730n3eb31c79a025d0ce@mail.gmail.com>
Date: Mon, 21 Jul 2008 12:44:30 +0200
From: "Joshua C." <joshuacov@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: ACPI: ACPI_CUSTOM_DSDT_INITRD option
Cc: joshuacov@googlemail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature was considered problematic for the 2.6.25 kernel. And the
0.9x version was rewritten to make the patch work better with the new
kernel (here it is: http://gaugusch.at/kernel.shtml ). What about
adding it to the new 2.6.27?
