Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYBALog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYBALog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbYBALo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:44:29 -0500
Received: from senator.holtmann.net ([87.106.208.187]:53873 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYBALo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:44:28 -0500
Subject: Build error on PowerPC
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 01 Feb 2008 12:44:39 +0100
Message-Id: <1201866279.6218.187.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get the following build error on PowerPC:

  CC [M]  sound/ppc/awacs.o
In file included from sound/ppc/awacs.c:25:
include/asm/nvram.h:62: error: field ‘partition’ has incomplete type
make[2]: *** [sound/ppc/awacs.o] Error 1
make[1]: *** [sound/ppc] Error 2
make: *** [sound] Error 2

Regards

Marcel


