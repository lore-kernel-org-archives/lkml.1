Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbXLIBh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbXLIBh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 20:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXLIBhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 20:37:13 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:50531 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXLIBhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 20:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ShUJQXdleMN0elMo7/74O7h7KnHVj2shd+Pq21NVVPEYcNnCaOYEvYLj/joVWhaUB5F1Qyj0rB+WW/8wY7EAfOOkkhCcDXjPhj8zsbTTlLmmA1uYVItx6+T3vsoteanVyo5NntO2onVtC7c2gCvu3rY0fThJ+NHg0uwdiRpYxAU=
Message-ID: <8b67d60712081737g2be31ad0j3006a89ef1db0c59@mail.gmail.com>
Date: Sun, 9 Dec 2007 01:37:09 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: rq_for_each_bio
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tried to search through the mailing list and it is not entirely
clear, but it looks like this has gone from the kernel: not least
because my driver reports:

drivers/sh/gdrom/gdrom.c:665: error: implicit declaration of function
'rq_for_each_bio'

I am not arguing for a stable ABI/API, I get that one - but is there a
canonical source of changes in the kernel (because unless you cross
reference lkml and git repos the mailing list isn't) and if there is -
how can we get it on the first page of google? :)

(Actually, forget the theologocal discussion, tell me about rq_for_each_bio)
