Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYC1RwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYC1RwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYC1RwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:52:16 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:56589 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYC1RwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AkUVUgV87dCNlH9LvI49aFff637p2ZMAz8Y/uHu5R0o0Z0QCxSYB7Ahe9dQC4o30mWfM9bgcNfPs/D/ij2wPAoBx3tA3XKCgaIc+HXuOD8vvuarRz29YVEdEzFjmz9Ly8/5i2g76JfPPqaKeJNi3P7349hxwdU9y7AwxJ71Q1ww=
Message-ID: <7b4bf7ff0803281052j3e5d57c9xf6d1f308c9d9cdb9@mail.gmail.com>
Date: Fri, 28 Mar 2008 18:52:14 +0100
From: "Olivier Cornu" <o.cornu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: What would your perfect language for Linux development look like?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I've recently started a toy project: a programming language aimed at
OS development only.
It's nothing revolutionary really and it will very likely never be
used by anyone - except perhaps me: the main intent is to learn more
about programming languages and OS specific needs in this regard (the
idea grew while playing with Linux and Minix C sources and reading
about OS design issues).

I would be glad to hear you share your experience about C as a
programming language in OS development context, like:
- what missing feature would you like C to have?
- what feature should be removed?
- what kind of language cleanup would you like to see?
In other words, what would your perfect language for Linux development
look like?

Regards,
Olivier
