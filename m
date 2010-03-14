Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0CNPtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 11:49:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:44682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0CNPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 11:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iF0EHaJtkaHZP4DlldW8I6jQzylBPrzSnFIjjqWa102oJ0snyCqF4Qg9QB0mv985D4
         XL+BPZRmjWB1Nv+gZiisI44KFr6LKUUj88YqHIn2fld2YSjIz+A3xNgOieYvO0/YxuDv
         JzFIFX+Ib/JI43fP5tGS4PWpE0Cafz3hPM/2w=
MIME-Version: 1.0
Date: Sun, 14 Mar 2010 17:49:31 +0200
Message-ID: <c1fb08351003140849l23e826d3hfddd3e2aa952d3e5@mail.gmail.com>
Subject: Leadtek WinFast PxPVR2200
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Toth <stoth@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in the file
drivers\media\video\cx23885\cx23885-cards.c

there is:
CX23885_BOARD_LEADTEK_WINFAST_PXTV1200

it is possible to add LeadTek WinFast PxPVR2200 to that file ?

it uses the CONEXANT PCIe A/V Decoder CX23885-13Z
and CONEXANT MPEG II A/V ENCODER CX23417-11Z
