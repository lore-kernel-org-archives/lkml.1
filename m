Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYFYTjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYFYTjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbYFYTjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:39:32 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:18766 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYFYTjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TMmi1Q1YHMHaCzmBgMkZIsxJxMWdWm2tSKcLsEAsJCZBRmAPD4tH8E5aL0rJkYJ1b2
         XstMi43vidfNSv0ZPlDkS59WUTlnCgFxSRPnkWuBMCGYaiz9Ys1E4oxBTd6urEm9V1rD
         jB5Px75iD293LCuYFNpHOt7L/ZBLu23u7901w=
Message-ID: <7871fcf50806251239p61ba15edw25d7f4a61ae7d7fc@mail.gmail.com>
Date: Wed, 25 Jun 2008 15:39:28 -0400
From: "Joel C. Salomon" <joelcsalomon@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Regenerating Module.symvers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I'm building kernel modules (for an in-house driver) that depend on
the RTAI modules being installed.  Trouble is, the computer I'm using
does not have the symbols from those modules listed in any
Module.symvers file.

Is there any way, short of rebuilding them, to dump the symbol
versions from existing modules?

I'm not subscribed; please CC me on replies.

--Joel Salomon
