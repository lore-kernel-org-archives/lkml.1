Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbXHAPhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbXHAPhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXHAPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:37:26 -0400
Received: from cnxtsmtp5.conexant.com ([198.62.9.40]:46038 "EHLO
	cnxtsmtp5.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbXHAPhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:37:25 -0400
X-Greylist: delayed 2012 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 11:37:25 EDT
X-WSS-ID: 0JM3OJN-02-5YW-02
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: netDMA on ARM?
Date: Wed, 1 Aug 2007 20:34:49 +0530
Message-ID: <02C837E0D6BC6741BD574EB1E35D900F01D4184B@hyd-mail2.bbnet.ad>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: netDMA on ARM?
Thread-Index: AcfUTU4GaBlRmS05QpqhM7bPTeuJ4A==
From: "Syed Khader" <syed.khader@conexant.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
I am trying to build netDMA support on linux-2.618.2 for arm-11 box.
  Firstly, is it possible build netDMA on non-intel platforms using
the host dma channels present in the hardware?
  Secondly does this improve network performance on non-intel platforms
without IOAT hardware support?

Thanks
Syed

Conexant E-mail Firewall (Conexant.Com) made the following annotations---------------------------------------------------------------------********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------
