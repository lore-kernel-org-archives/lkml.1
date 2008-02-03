Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbYBCRKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbYBCRKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbYBCRJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:09:52 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:43033 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbYBCRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:09:51 -0500
From: Christian =?iso-8859-15?q?Borntr=E4ger?= 
	<christian@borntraeger.net>
To: Jack Byer <ojbyer@usa.net>
Subject: Re: 2.6.24 module problem
Date: Sun, 3 Feb 2008 18:09:48 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <fo4p9v$ve7$1@ger.gmane.org>
In-Reply-To: <fo4p9v$ve7$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031809.48369.christian@borntraeger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 3. Februar 2008 schrieb Jack Byer:
> PAX: modprobe:752, uid/euid: 0/0, invalid execution attempt at 

This looks like an issue with PAX - grsecurity@grsecurity.net might be a 
better list to ask.

Christian
