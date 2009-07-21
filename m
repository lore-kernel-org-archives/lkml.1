Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZGUKpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZGUKpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZGUKpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:45:23 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33773 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZGUKpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nWCiuzeOn5l5+wq6FYV5N7m9JDExwPy+O9bl6LhVRDGkVyPnHkI1B4uUc9k4QeC3K2
         2atKF1iBZNGKFUTKafjObY27K6LxV1g6cKndwR3EUnQDoBDBoJtXeUIXCcbkLDbZpF5i
         SvRZRrKm/50p+xKvX/eZ6zx07FKJLPveCBqgI=
MIME-Version: 1.0
Date: Tue, 21 Jul 2009 12:45:21 +0200
Message-ID: <b08bcbf50907210345g4f25e334k11282f44618440b4@mail.gmail.com>
Subject: Kevent and netif_queue_stopped()
From: Gallus <gall.cwpl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
is it possible to wait for netif_queue_stopped by using kevent or
similar interface?

Regards,
Gallus
