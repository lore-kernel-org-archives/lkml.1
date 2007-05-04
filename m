Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXEDP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXEDP3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXEDP3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:29:23 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:33674 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152AbXEDP3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:29:22 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [patch]clarification of coding style regarding conditional statements with two branches
Date: Fri, 4 May 2007 17:29:04 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200705040926.55257.oliver@neukum.org> <463B47AF.4010503@gmail.com>
In-Reply-To: <463B47AF.4010503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705041729.04771.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Mai 2007 16:48 schrieb Jiri Slaby:
> Why, what's wrong with
> if (condition) {
>         do_this();
>         do_that();
> } else
>         otherwise();
> 
> ? It's more readable/nicer in my eyes than

Than I am afraid we need to agree to disagree. But then I would
insist that neither side give the other a hard to time over this issue.

	Regards
		Oliver
