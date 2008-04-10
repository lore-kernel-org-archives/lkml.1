Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYDJIPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYDJIPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbYDJIOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:14:35 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:2432 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbYDJIOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:14:33 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: Starting point: Suspend to RAM on embedded devices?
Date: Thu, 10 Apr 2008 10:14:30 +0200
Message-ID: <83116F0A4FF67A4F97BA0B6E408C48E301E96208@zuerich.BC-Int.NET>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Starting point: Suspend to RAM on embedded devices?
Thread-Index: Ach0m4cSiApNdLdFScC3DSTHVH8H7w==
From: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2008 08:14:41.0600 (UTC) FILETIME=[ED627C00:01C89AE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am looking for ways to let an ARM9 based embedded device running Linux go to a "suspend to RAM" like mode. In my opinion this
could enable a HIFI equipement like "power-off" and "power-on" feeling with quick response (less than 2 seconds) and much less power
consumption in the standby mode than during normal operation.

- Is there public available documentation about APM like features on ARM architectures?
- Is there a mainstream Linux platform (best if also ARM9 based) which has achieved this already?
- I am also interested in experiences with applications running on such platforms, 
  trigger like systems which inform the apps and so on...

Thank you Marcel
(please CC me on replay)
--
Marcel Wappler
Bridgeco AG
CH-8600 Dübendorf
Switzerland
