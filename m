Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZLNOgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZLNOgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:36:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZLNOgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:36:04 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:33269 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZLNOgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:36:01 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Masa <masa.korg@gmail.com>
Subject: Re: [How to upload our driver to "kernel.org"] Would you give me your advice?
Date: Mon, 14 Dec 2009 15:36:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alejandro Riveira =?iso-8859-1?q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       devel@driverdev.osuosl.org
References: <c7ac85d60912140256j4e1aa0edn9abba53ab1855ed5@mail.gmail.com> <20091214122649.2d914941@varda> <c7ac85d60912140610o1de69703x4d42108b4519ede@mail.gmail.com>
In-Reply-To: <c7ac85d60912140610o1de69703x4d42108b4519ede@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912141536.14266.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Dezember 2009 15:10:42 schrieb Masa:
> > Adding I hpe some usefull CC's
> > See also: http://www.linuxdriverproject.org/
> Last week, I saw it.
> But, I could not find the information for "How to upload".

You don't, technically speaking, upload.
You make a patch against a current kernel tree and mail it
to the relevant list. Then people will tell you what's wrong with your
code and how it should be improved. After you'll have fixed
the issues, the maintainer will take your patch and it'll be
incorporated into the kernel tree at kernel.org.

	HTH
		Oliver
