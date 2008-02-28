Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYB1OHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYB1OHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYB1OH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:07:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:56166 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYB1OH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:07:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c61yEk6QYI1kYBwyPhgsrF21ZYgW1z6i8+BRFICwn9Hb4znMM/lW4Wfp5uWp82fDgyIECtI1dm27zzWt+7E++fIUnmaGm8D2LqSsIhlwIrBkDMzccO1KT5uRYwIsrF+GrCQrek0ckXOR2qLSLU0iarwUuMV7qJ6uw+zscnC2kC8=
Message-ID: <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com>
Date: Thu, 28 Feb 2008 15:07:27 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: linux-v2.6.25-rc3 issue: nvidiafb: cannot ioremap FB base
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I gave to the latest -rc (rc3) a test and it appears to fail to load the
nvidiafb module and the reason given is:

nvidiafb: cannot ioremap FB base

Does anybody have a clue ?

Full dmesg output is attached.

Thanks
-- 
Francis
