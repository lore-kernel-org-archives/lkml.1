Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYEGVjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYEGVjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYEGVjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:39:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:14508 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbYEGVje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=C9JwdyJ4yCJGQYRZsK46W/Ce6CjVBAYQKy/mUKBF9lxrisqfTDgRbxnrgRZhG47EERbYuRqvAQQsVEmeu9VCqlrxN90PYwzS+S+PYJtmMjZ1WKlIhKojMMhFO8/2CqC7HPjnv+wvz+aLu8QmsfOx+ZEkcnXmm8K0hNDRniycJEU=
Message-ID: <b637ec0b0805071439j2de1a585pa00812b703ea646b@mail.gmail.com>
Date: Wed, 7 May 2008 23:39:23 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: kernel 2.6.26-git - ACPI: EC: GPE storm detected, disabling EC GPE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
The line in the subject is printed on the screen at every boot. It
never happened before. Is it something to worry about?
Also, there is this new line:

BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)

FWIW, the machine is an HP DV4378EA laptop, so if there's someone from
HP listening...

cheers,
Fabio
