Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZDVNPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZDVNPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZDVNOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:14:49 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:48163 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZDVNOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:14:49 -0400
From: Oliver Neukum <oliver@neukum.org>
To: =?utf-8?q?Mar=C3=B3y_=C3=81kos?= <akos@maroy.hu>
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
Date: Wed, 22 Apr 2009 15:14:34 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <49EDC44D.90106@maroy.hu> <200904211952.25616.oliver@neukum.org> <49EF0ED7.3060706@maroy.hu>
In-Reply-To: <49EF0ED7.3060706@maroy.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904221514.34892.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 22 April 2009 14:34:31 schrieb Maróy Ákos:
> what could be the problem?

That's odd. I can't tell from the log. Can you make a usbmon trace?

	Regards
		Oliver

