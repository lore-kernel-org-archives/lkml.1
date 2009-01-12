Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZALRac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZALRac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZALRaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:30:24 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:39369 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZALRaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:30:23 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: question on line disciplines
Date: Mon, 12 Jan 2009 18:30:40 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121830.41333.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a few years ago we had trouble with a line discipline that assumed
that room for more than 1 byte meant that two single pushes of one
byte each were possible. Is that still the case?

	TIA
		Oliver
