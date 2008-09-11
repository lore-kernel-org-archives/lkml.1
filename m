Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYIKSeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYIKSeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYIKSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:34:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbYIKSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:34:29 -0400
Date: 11 Sep 2008 20:24:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: corbet@lwn.net
Cc: j@jannau.net
Cc: jwilson@redhat.com
Cc: linux-kernel@vger.kernel.org
Cc: matthew.bodkin@innovationone.ca
Message-ID: <AlfDeGfojFB@christoph>
In-Reply-To: <20080910110904.54de7268@bike.lwn.net>
Subject: Re: [PATCH 07/18] lirc driver for the CommandIR USB Transceiver
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/pSyY/mnQLjNuaoXD33BGJYdSoiSQknRSV6yL
 IsTIPLqV3H5Zm0xyP1+srTBl3xyKDUGVEAwA3x5uCPBtXbOAvx
 z9OpjbQy/uVYyc1cK+Wyqj+9AW/nF6bnP/FFEgMfp8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there is a user-space driver that is going to replace the kernel driver  
for the CommandIR driver. I don't think there is a reason anymore to get  
this driver into the kernel.
Added, Matthew.

Christoph
