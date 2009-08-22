Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbZHVEtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbZHVEtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 00:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZHVEtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 00:49:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:1761 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZHVEtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 00:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=TCxacuoFBjSKQHAwMlej8zfuRup9AkctCZf4YGnIUlq55hNQM3QitCIBXwhONi+S10
         rMZdq7pBMpjG2Ir+dNRi6Sc0MhYaVHCfsyN8nb1zs8WoRkajye5fF772BspYWf1Uset6
         qDn6WfetXQBV78Cnv3E6+WCyXzP/OR8Rnox3k=
MIME-Version: 1.0
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sat, 22 Aug 2009 07:48:50 +0300
Message-ID: <12d7e64c0908212148t729ab1cbyc60b056180dbc52@mail.gmail.com>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RE: http://marc.info/?l=linux-kernel&m=125091287004799

http://bugzilla.kernel.org/show_bug.cgi?id=13967

Linux 2.6.31 intentionally broke lm_sensors drivers for lots of
people. It's a feature.
