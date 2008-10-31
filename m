Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYJaGkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYJaGkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 02:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYJaGkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 02:40:37 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:44816 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYJaGkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 02:40:37 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [RFC] B+Tree library
Date: Fri, 31 Oct 2008 07:38:46 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20081026124643.GA1328@logfs.org> <20081030174300.GA1773@ucw.cz> <20081030175844.GC7157@logfs.org>
In-Reply-To: <20081030175844.GC7157@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810310738.46326.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 30. Oktober 2008 schrieb Jörn Engel:
> Except that min/max in include/linux/kernel.h have some type-safety
> added.  In this particular case that is actually a disadvantage:

So what about min_t and max_t from include/linux/kernel.h? Can that be used?

Christian
