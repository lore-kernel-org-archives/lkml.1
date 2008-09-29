Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYI2GaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYI2GaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 02:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYI2GaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 02:30:06 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:8751 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYI2GaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 02:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=bNCNH+C9xltgu9NiudADDwuljQX6X+Fw4o45ZDMVWbUwno/SVkbrtsh0azXjcK/SOh
         WHSHYa8sXchcnDOWl+NYsW1+fihdKQgrX+YnaLkns9R9mCB7kVZFcebH/drzqvforwro
         xMDXAKWZ4X3P+F6Y90bQcfUXRoK0HqINxylbw=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/3] ide-cd: debug log enhancements
Date: Mon, 29 Sep 2008 08:29:56 +0200
Message-Id: <1222669799-6565-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are some trivial enhancements to ide-cd which resulted from the debugging
sessions lately.

 drivers/ide/ide-cd.c |   44 ++++++++++++++++++++++++++------------------
 1 files changed, 26 insertions(+), 18 deletions(-)
