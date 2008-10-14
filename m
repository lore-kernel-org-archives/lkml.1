Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYJNXXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYJNXXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYJNXXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:23:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13764 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYJNXXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KvfoyeDH5PeRZCShAy3DmLK9SdDKWsAowPjFLDfNpNkncNqTHjfv9TmadK+7TdN84G
         Py9ppvNJtvJp5CqFJ3PtVr7b727G13Ql/KfXGWRiuy1hfUxy+eW/lp+pvWhsRHzkJ73D
         ODLeOjGbKnHGywW/q4IVP8e4I4YkTZ8O/CPUc=
Message-ID: <3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
Date: Tue, 14 Oct 2008 16:23:37 -0700
From: "Kaz Kylheku" <kkylheku@gmail.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48F5193B.1010601@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
	 <48F5193B.1010601@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 3:12 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> Kaz Kylheku wrote:
>
>> I have the following question. Suppose that some proprietary driver
>> (otherwise completely clean, based only on non-GPL symbols)
>
> The fact that it's not using GPL symbols does not actually mean that the
> driver is not a derivative work of the kernel (and thus subject to the GPL).

But thanks to the gracious tolerance of the kernel development
community, such drivers are permitted to exist. That is the question:
setting aside GPL chapter and verse, could that tolerance extend
to allow such a driver to get a piece of boot-time memory, and if so,
what mechanism would be tolerated?
