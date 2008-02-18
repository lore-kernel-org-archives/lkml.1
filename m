Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbYBRVsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbYBRVsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbYBRVrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:47:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:32722 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbYBRVry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FHMmfF4RoglyGn+04tyXaIFnA029TIlN2DvDYtk/FPlQ+5C4VAD8mKsc+dbAdTXcDnHO05sUIkszTPQR+h4g/3XBp0CxJB3vRmss8mr5srWzSX7POu1xdIlGpdL9p/aJwRfm03WV1hU0+0N3HsAYERwA1WJZrmbqFWuy6GltyO4=
Message-ID: <934f64a20802181347q43e1b350tc61265e89b7e4d5c@mail.gmail.com>
Date: Mon, 18 Feb 2008 15:47:52 -0600
From: "David Nicol" <davidnicol@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: boot parameter to override a built-in initramfs?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

noinitrd doesn't do anything; init=/bin/sh doesn't do anything

how does one override a built-in initramfs?
