Return-Path: <linux-kernel-owner+w=401wt.eu-S932677AbZJ3QfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbZJ3QfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbZJ3QfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:35:03 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42806 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbZJ3QfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=yB2Y3AxO1O/+rra/0y4sr900XOlUNW4QpMnIy9VB/qv8HQl5JQX0/ON35WJoNP2coA
         OVO61jZY95G1keijOBR8nInLdXUq8cIFFSXR/fFCQevfjJrFmPdB6SySu5l4oW5y/sQU
         uRxlohp3mF/gxtRW0k45G7FXtV+11a67QNWas=
MIME-Version: 1.0
Date: Fri, 30 Oct 2009 13:35:07 -0300
Message-ID: <6217e0a0910300935l3e2d279fr5b889a4929a9912d@mail.gmail.com>
Subject: Initialize a runqueue
From: Lucas Prado Melo <lucaspradomelo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I would like to know where the runqueue structs are initialized.

Thanks in advance.
