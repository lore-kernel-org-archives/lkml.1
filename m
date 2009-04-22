Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZDVQhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZDVQhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZDVQhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:37:11 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:47821 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZDVQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:37:09 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 12:37:09 EDT
Message-Id: <cover.1240410708.git.keil@b1-systems.de>
From: "Karsten Keil" <Karsten-Keil@t-online.de>
Subject: [PATCH 0/3] [ISDN] Documentation patchset
Date: Wed, 22 Apr 2009 16:31:48 +0200
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, David Miller <davem@davemloft.net>,
       tilman@imap.cc, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org
X-ID: XLtoZkZdZhGMLRSaACNgmS70Gvxzz5pWEWt8uwTp01ITWjXVdidKi9tvGbZNdfLZyh
X-TOI-MSGID: c25f1c13-4f5c-4be8-bcaa-8e6d3b6270f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some useful documentation for the ISDN subsystem.
Orignal patches are from Tilman Schmidt.
I fixed some whitespace issues and added the URL for the CAPI 2.0 spec.


Karsten Keil (1):
  Add reference to CAPI 2.0 standard

Tilman Schmidt (2):
  update Documentation/isdn/00-INDEX
  Documentation/isdn/INTERFACE.CAPI

 Documentation/isdn/00-INDEX       |   17 +++-
 Documentation/isdn/INTERFACE.CAPI |  208 +++++++++++++++++++++++++++++++++++++
 drivers/isdn/capi/kcapi.c         |  171 ++++++++++++++++++++++++++++++
 3 files changed, 392 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/isdn/INTERFACE.CAPI

