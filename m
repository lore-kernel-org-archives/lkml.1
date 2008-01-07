Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYAGMsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYAGMsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbYAGMsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:48:06 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38522 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbYAGMsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:48:04 -0500
From: "S, Prathiba" <pratibha.s@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Jan 2008 12:47:59 +0000
Subject: Deprecated SCSI ioctl, please convert it to SG_IO
Thread-Topic: Deprecated SCSI ioctl, please convert it to SG_IO
Thread-Index: AchRKlLhnaXXd2sUQ6a5BpfEYMusCAAAEIsQ
Message-ID: <64168A03AD4CA74FAE60B01011D9A37D27BB02DC13@G1W0490.americas.hpqcorp.net>
References: <20080107133816.A11860@sedona.ch.intel.com>
In-Reply-To: <20080107133816.A11860@sedona.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Using one of the application to write on the device through scsi, I get the following
Message "Deprecated SCSI ioctl, please convert it to SG_IO". This message is from
System log file. It seems to be kernel message.

Does any kernel settings is required to overcome this warning message ?

I searched in mailing list, but I couldn't get succeed, may be I was not
using the right keyword.

Can some help me in solving this issue.

Regards,
Prathiba
