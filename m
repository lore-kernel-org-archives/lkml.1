Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXHADDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXHADDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXHADDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:03:34 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:43299 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbXHADDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=l+QHGrnHi2lzgRWjiSc1vCD835XdYdRJu72SMtcc4M+5T8YlHQLY2ZenscjQzqXii/3AIRl+oDDppb/m58BgpCrxdnipWULMntn36M+oktE9Fmp9PAyx1Hq2pVz2xXNEG4XiGToNmFjjyHSCGbN2tn95eLA1TqsiulQePpiG/AE=
Message-ID: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
Date: Wed, 1 Aug 2007 03:03:31 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: wim@iguana.be
Subject: eurotechwdt will cause reboot
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
config eurotechwdt to yes will cause system silent reboot. Is it right
behaviour or a bug?

Regards
dave
