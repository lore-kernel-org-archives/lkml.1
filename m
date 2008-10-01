Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbYJAV5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbYJAV5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYJAV5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:57:44 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46393 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYJAV5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:57:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JlDaDCfUX5iS5oq4J0g8GaZiSBhQmoCkBTAklQu4B3yAZx6kVWCQF5Zut/nIljnvQo
         jPoMXQyspb/+X9Y3JG9IR6T/9RJCbBDFG4FYWkTtiCBULq1+cMNFtU7+KnhDb6JEKgWa
         vzvnrJvnzrMbBELvUDlUH1Db/P4ut3GqzEY34=
Message-ID: <1a26b4920810011457t4ad93308u2cc0d2781168f332@mail.gmail.com>
Date: Wed, 1 Oct 2008 23:57:43 +0200
From: "Pazzo Da Legare" <pazzodalegare@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: booting uncompressed kernel on x86
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to boot uncompressed linux kernel on a embedded x86,
should I apply a specific patch for this? I'm using grub boot loader
which should boot using elf image but I cannot find any clue.
Should I switch to another bootloader?

TIA

pazzodalegare
