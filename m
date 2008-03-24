Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYCXXaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYCXXaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYCXXag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:30:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:53100 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbYCXXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JejbO3sYlD2wqzua/Hwu/D9TFA1TqsDOlU6i4FgQMSR1kvzs33Y6jxEo9Sd02UZFYOJOz/bfZYaERop6XE3ywBxl1CzeI5OvREWEUYcDwpOpOHxXdLnInrRORAmJSF/4ZNEXVKRO2bL/QdWIOCM9GPMZHm+vUrfzCyPIYJ7ZMNA=
Message-ID: <df47b87a0803241630u5475fb00l4c76fc709af31a7f@mail.gmail.com>
Date: Tue, 25 Mar 2008 01:30:33 +0200
From: "Ioan Ionita" <opslynx@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: 2.6.25-rc5-git5 KVM memory not freed
Cc: "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <47E64B27.3060400@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df47b87a0803200941q7cbee10ev5a57f7cb25406896@mail.gmail.com>
	 <47E63161.90002@qumranet.com> <47E64B27.3060400@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 2:20 PM, Avi Kivity <avi@qumranet.com> wrote:

>  Attached patch ought to fix this.

I confirmed! Regression is fixed. Thank you! Will it be pushed
upstream for 2.6.25?

Kudos!
