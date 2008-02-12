Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbYBLK3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbYBLK3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 05:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762482AbYBLK26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 05:28:58 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:39190 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762459AbYBLK24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 05:28:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Xtly1M5pRAbjSBfBpDh03LgdfS3eIHADoVOgbyWSY8r7BJrn4v2iJRncFzgY95YcC7lku0RoSqt3ElECXW6HlHt4mTNY6q5glb8wgnREPyW6dVBpsoG03MBoexW7oBLqC5Sx5yXlomODVyQbTE66TwNSIJAS/YoCY6VzwhIjHAw=  ;
X-YMail-OSG: t3ON0TQVM1lbYNCnaGNy3_ncP94OfXVgp9JEB9AL7_VOYJz70eNIUas_EUlsjujZ1WMQ0MbjOA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg devices
Date: Tue, 12 Feb 2008 02:28:53 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       me@felipebalbi.com
References: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120228.54123.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Felipe Balbi wrote:
> Some devices claim
> to be b_host even though they have an a_connector attached to it.

Why not just fix that bug?  Remember that's Linux code.

