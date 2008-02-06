Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYBFIOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYBFIOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbYBFIOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:14:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:44478 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYBFIOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RXRs2mz1DI6FP65SSVQotDBtUbF8frtbcEOkjivw8gQx+R201g7CTnep89d4z9XWdF+FCQr/rDaA4LIof4OGRpsxOOhwnEHhcHGTaBaM+0ZArRUbCnBVWuE6VZtGs2N6+eHZd4ZudxDsNquHDx3QuudYXIY1HT9ULG4if0yf8uU=
Message-ID: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com>
Date: Wed, 6 Feb 2008 16:13:59 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: where is the capset kernel module?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest linux git complained about this ...

named: capset failed: Operation not permitted: please ensure that the
capset kernel module is loaded.  see insmod(8)

Where is the capset kernel module?

Thanks,
Jeff.
