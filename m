Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYKCOZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYKCOZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbYKCOY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:24:57 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:12102 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbYKCOY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:24:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=L/5Y25oxGu3Q+6qYFarg7LPrl4phom5VLtPwMQhRBsgkYgf+0sEzZuu1Ve5XcuB9ih
         a0Rs188IAsleW31LlSJt3wcugx83rbwdFZoMq+qFCG92mWsB3W8c+yn8JnQcJ4vQTgyP
         gp1AHe9NIGcARYbagmkSU31KuKmV0RpNDMJAQ=
Message-ID: <dd18b0c30811030624o2d8fe46u1e3e82d6f6b94481@mail.gmail.com>
Date: Mon, 3 Nov 2008 06:24:53 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF:
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm,
This is weired; I'm not sure but I think this might
be caused by acpid or something in that area, i.g.
doing a fresh install and loading the latest git leaves me
without a warning message, but then after upgrading to intrepid
I see this:
[   11.116543] ACPI Warning (nspredef-0858): \_SB_.BAT0._BIF: Return
Package type mismatch at index 9 - found Buffer, expected String
[20080926]


-- 
Justin P. Mattock
