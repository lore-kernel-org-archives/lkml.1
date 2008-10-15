Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYJOMJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYJOMJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYJOMJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:09:07 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:50668 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbYJOMJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:09:06 -0400
From: Bodo Eggert 
	<arcoristkaputtundbrauchtdiesentext.7eggert@nurfuerspam.de>
Subject: Fwd: Re: Perfectly Random
To: linux-kernel@vger.kernel.org, Glenn Powers <glenn@meaning.com>
Date: Wed, 15 Oct 2008 14:20:03 +0200
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Kq5MB-0001Td-Dn@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: arcoristkaputtundbrauchtdiesentext.7eggert@nurfuerspam.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glenn Powers <glenn@meaning.com> wrote:

> This is a proposal for a linux kernel module. This module will transfer
> entropy to /dev/random from nuclear decay random number generators.

Transfering randomness to /dev/random should usually be done in userspace.
This allows more complex analysis (like: Is the generator working correctly?).


