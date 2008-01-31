Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbYAaIHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbYAaIHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYAaIHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:07:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:53647 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYAaIHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uXSUmofVrqEdSQFF/pjnQ1kCxocrIOl4X/1ycnVrx1SemulQrd0KwO4CGHMqrHmISspOCAPYb9lfAilBHWS7T7ZuU58WGdsZtEWfcOlivguJ4L47Mw3bWGq0dOE3pvr3n6lk87WKeD8Q3npueQrv5wSBHHEYLDP8i4ZbEtC2Ehk=
Message-ID: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com>
Date: Thu, 31 Jan 2008 00:07:04 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: about relocs.c on x86
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

why not rename relocs.c to relocs_32.c?

it is only used for 32 bit, even it is host app.

YH
